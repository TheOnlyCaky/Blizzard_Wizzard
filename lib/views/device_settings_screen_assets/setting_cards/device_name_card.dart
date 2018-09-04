import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';
import 'package:blizzard_wizzard/controllers/wait_for_packet.dart';

class DeviceNameCard extends SettingsCard {

  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  DeviceNameCard(device, alertMessage) : super(device, alertMessage);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: new Form(
        key: _formKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Device Name'
              ),
              maxLength: BlizzardWizzardConfigs.longNameLength,
              maxLengthEnforced: true,
              validator: _validate,
              onSaved: _onSave,
            ),
            new ButtonTheme.bar( // make buttons use the appropriate styles for cards
              child: new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: const Text('CLEAR'),
                    onPressed: () { _onClear(); },
                  ),
                  new FlatButton(
                    child: const Text('SUBMIT'),
                    onPressed: () { submit(); },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
  // First validate form.
    print("submit");
    if (_formKey.currentState.validate()) {
      print("save");
      _formKey.currentState.save(); // Save our form now.
    }
  }

  String _validate(String input){
    return null;
  }

  void _onClear(){
    print("clear");
    _formKey.currentState.reset();
  }

  void _onSave(String input){

    tron.addToWaitingList(WaitForPacket(_submitCallback,
        this.device.address, 
        ArtnetPollReplyPacket.opCode, 
        BlizzardWizzardConfigs.artnetConfigCallbackTimout)
    );

    tron.server.sendPacket(_populateConfigPacket(input).udpPacket, this.device.address);

  }

  void _submitCallback(List<int> data){
    if(data == null){
      alertMessage("Change name failed");
    } else {
      alertMessage("Name changed to " + String.fromCharCodes(data.getRange(ArtnetPollReplyPacket.longNameIndex, ArtnetPollReplyPacket.longNameSize)));
    }
  }

  ArtnetAddressPacket _populateConfigPacket(String name){
    ArtnetAddressPacket packet = ArtnetAddressPacket();
    String longName = (name.length > BlizzardWizzardConfigs.longNameLength) ? name.substring(0, BlizzardWizzardConfigs.longNameLength - 1) : name;
    String shortName = (name.length > BlizzardWizzardConfigs.shortNameLength) ? name.substring(0, BlizzardWizzardConfigs.shortNameLength - 1) : name;


    packet.programNetSwitchEnable = false;
    packet.programSubSwitchEnable = false;
    packet.programUniverseEnable = false;

    packet.longName = longName;
    packet.shortName = shortName;

    return packet;
  }
}