import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';
import 'package:blizzard_wizzard/controllers/wait_for_packet.dart';

class SubnetCard extends SettingsCard {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<int> subnet = List<int>(4);

  SubnetCard(device, onSubmit, onReturn) : super(device, onSubmit, onReturn);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: new Form(
        key: _formKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(height: 3.0),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container()
                ),
                Expanded(
                  flex:2,
                  child: Text(
                    "Subnet",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Theme.of(context).hintColor
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "255",
                      isDense: true,
                    ),
                    enabled: !device.isDHCP,
                    keyboardType: TextInputType.number,
                    validator: _validateIP,
                    onSaved: (subnet){this.subnet[0] = int.parse(subnet);},
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "255",
                      isDense: true,
                    ),
                    enabled: !device.isDHCP,
                    keyboardType: TextInputType.number,
                    validator: _validateIP,
                    onSaved: (subnet){this.subnet[1] = int.parse(subnet);},
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "255",
                      isDense: true,
                    ),
                    enabled: !device.isDHCP,
                    keyboardType: TextInputType.number,
                    validator: _validateIP,
                    onSaved: (subnet){this.subnet[2] = int.parse(subnet);},
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "0",
                      isDense: true,
                    ),
                    enabled: !device.isDHCP,
                    keyboardType: TextInputType.number,
                    validator: _validateIP,
                    onSaved: (subnet){this.subnet[3] = int.parse(subnet);},
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container()
                ),
              ],
            ),
            Container(height: 2.0),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container()
                ),
                Expanded(
                  flex: 1,
                  child: Tooltip(
                    message: (device.isDHCP) ? "Turn off DHCP to edit Submask" : "Edit the Subnet of the device",
                    preferBelow: false,
                    child: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).disabledColor,
                    ),
                  )
                ),
                Expanded(
                  flex: 13,
                  child:ButtonTheme.bar( // make buttons use the appropriate styles for cards
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('CLEAR'),
                          onPressed: (){ _onClear(); },
                        ),
                        FlatButton(
                          child: const Text('SUBMIT'),
                          onPressed: (){ _submit(); }
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(height: 3.0),
          ],
        ),
      ),
    );

  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _sendCommand();
    }
  }

  String _validateIP(String input){
    var val = int.parse(input);
    if(val is int){
      if(val <= 0xFF && val >= 0x00){
        return null;
      }
    }
    return "0-255";
  }

  void _onClear(){
    _formKey.currentState.reset();
  }

  void _sendCommand(){
    
    this.onSubmit("Dehance");

    tron.addToWaitingList(
      WaitForPacket(this.onReturn,
        this.device.address, 
        ArtnetIpProgPacket.opCode, 
        Duration(seconds: BlizzardWizzardConfigs.artnetConfigNeverReturnTimeout),
        onFailure: "Failed to change Netmask",
        onSuccess: "Netmask changed",
      )
    );

    tron.server.sendPacket(_populateConfigPacket().udpPacket, this.device.address);
  }

  ArtnetIpProgPacket _populateConfigPacket(){
    ArtnetIpProgPacket packet = ArtnetIpProgPacket();

    packet.commandProgrammingEnable = true;
    packet.commandDHCPEnable = false;
    packet.commandProgramSubnet = true;

    packet.ip = this.subnet;

    return packet;
  }
}
