spacehud = spacehud or {}
spacehud.debug = spacehud.debug or 0
spacehud.ships = spacehud.ships or {}
spacehud.ship_candidates = spacehud.ship_candidates or {}
spacehud.my_ship = spacehud.my_ship or {}
spacehud.input = spacehud.input or {}
spacehud.label = spacehud.label or {}
spacehud.sort_by = spacehud.sort_by or "proximity"
spacehud.sort_by_invert = spacehud.sort_by_invert or -1
spacehud.type_width = spacehud.type_width or 35
spacehud.name_width = spacehud.name_width or 25
spacehud.xyz_width = spacehud.xyz_width or 10
spacehud.proximity_width = spacehud.proximity_width or 7
spacehud.position_width = spacehud.position_width or 5
spacehud.velocity_width = spacehud.velocity_width or 7
spacehud.font_size = spacehud.font_size or 8
spacehud.menu = {}
spacehud.menu.adjLabelstyle = [[
  border: 1px solid rgb(32,34,37);
  background-color: rgb(54, 57, 63);
]]
spacehud.menu.buttonStyle = [[
  QLabel{ background-color: rgba(32,34,37,100%);}
  QLabel::hover{ background-color: rgba(40,43,46,100%);}
]]
spacehud.menu.buttonFontSize = 10

spacehud.button_style =[[
  QLabel{ border-radius: 25px; background-color: rgba(41,43,47,100%)}
  QLabel::hover{ background-color: rgba(51,54,60,100%);}
  color: rgb(216,217,218) 
]]
spacehud.input_style =[[
  QPlainTextEdit{
    border: 1px solid rgb(32,34,37);
    background-color: rgb(64,68,75);
    font: bold 12pt "Arial";
    color: rgb(255,255,255);
  }
]]
spacehud.label_style =[[
  border: 1px solid rgb(32,34,37);
  background-color: rgb(47,49,54);
  font: bold 20pt "Arial";
  color: rgb(0,0,0);
  qproperty-alignment: 'AlignVCenter|AlignRight';
]]

spacehud.container = Adjustable.Container:new({
  name="spacehud_container",
  titleTxtColor = "white",
  titleText = "SpaceHud",
  width = "45%",
  height = "50%",
  x = "-45%", y = "0%",
  adjLabelstyle = spacehud.menu.adjLabelstyle,
  buttonstyle = spacehud.menu.buttonStyle,
  buttonFontSize = 10,
  buttonsize = 20,
  padding = 10
})

spacehud.console = Geyser.MiniConsole:new({
  name="spacehud_console",
  x="0%", y="3%",
  autoWrap = true,
  color = "black",
  scrollBar = true,
  fontSize = spacehud.font_size,
  width="100%", height="97%",
}, spacehud.container)

spacehud.settings_button = Geyser.Label:new({
  name="settings_button",
  x="3px", y="-29px", width="75px", height="25px",
  message="<center>Settings</center>"
}, spacehud.container)
spacehud.settings_button:setStyleSheet(spacehud.button_style)
spacehud.settings_button:setClickCallback("clickSettings")

spacehud.settings_container = Adjustable.Container:new({
  x="33%", y="20%",
  name = "spacehud_settings",
  --width = "35%", height = "35%",
  width = "230px", height = "250px",
  adjLabelstyle = spacehud.menu.adjLabelstyle,
  buttonstyle = spacehud.menu.buttonStyle,
  buttonFontSize = 10,
  buttonsize = 20,
  titleText = "",
  titleTxtColor = "white",
  padding = 10
}, spacehud.container)

spacehud.save_button = Geyser.Label:new({
  name="save_button",
  x="33%", y="-25px", width="50px", height="25px",
  message="<center>Save</center>"
}, spacehud.settings_container)
spacehud.save_button:setClickCallback("clickSave")
spacehud.save_button:setStyleSheet(spacehud.button_style)

spacehud.label.type = Geyser.Label:new({
  name = "label_type",
  x = 0, y=0, width="150px", height="25px",
  message = "Type width:"
}, spacehud.settings_container)
spacehud.label.type:setStyleSheet(spacehud.label_style)

spacehud.input.type = Geyser.CommandLine:new({
  name = "input_type",
  x = "150px", y=0, width="50px", height = "25px"
}, spacehud.settings_container)
spacehud.input.type:setStyleSheet(spacehud.input_style)

spacehud.label.name = Geyser.Label:new({
  name = "label_name",
  x = 0, y="25px", width="150px", height="25px",
  message = "Name width:"
}, spacehud.settings_container)
spacehud.label.name:setStyleSheet(spacehud.label_style)

spacehud.input.name = Geyser.CommandLine:new({
  name = "input_name",
  x="150px", y="25px", width="50px", height="25px"
}, spacehud.settings_container)
spacehud.input.name:setStyleSheet(spacehud.input_style)

spacehud.label.xyz = Geyser.Label:new({
  name = "label_xyz",
  x = 0, y="50px", width="150px", height="25px",
  message ="Xyz width:"
}, spacehud.settings_container)
spacehud.label.xyz:setStyleSheet(spacehud.label_style)

spacehud.input.xyz = Geyser.CommandLine:new({
  name = "input_xyz",
  x="150px", y="50px", width="50px", height="25px"
}, spacehud.settings_container)
spacehud.input.xyz:setStyleSheet(spacehud.input_style)

spacehud.label.proximity = Geyser.Label:new({
  name = "label_proximity",
  x = 0, y="75px", width="150px", height="25px",
  message ="Proximity width:"
}, spacehud.settings_container)
spacehud.label.proximity:setStyleSheet(spacehud.label_style)

spacehud.input.proximity = Geyser.CommandLine:new({
  name = "input_proximity",
  x="150px", y="75px", width="50px", height="25px"
}, spacehud.settings_container)
spacehud.input.proximity:setStyleSheet(spacehud.input_style)

spacehud.label.position = Geyser.Label:new({
  name = "label_position",
  x = 0, y="100px", width="150px", height="25px",
  message ="Position width:"
}, spacehud.settings_container)
spacehud.label.position:setStyleSheet(spacehud.label_style)

spacehud.input.position = Geyser.CommandLine:new({
  name = "input_position",
  x="150px", y="100px", width="50px", height="25px"
}, spacehud.settings_container)
spacehud.input.position:setStyleSheet(spacehud.input_style)

spacehud.label.velocity = Geyser.Label:new({
  name = "label_velocity",
  x = 0, y="125px", width="150px", height="25px",
  message ="Velocity width:"
}, spacehud.settings_container)
spacehud.label.velocity:setStyleSheet(spacehud.label_style)

spacehud.input.velocity = Geyser.CommandLine:new({
  name = "input_velocity",
  x="150px", y="125px", width="50px", height="25px"
}, spacehud.settings_container)
spacehud.input.velocity:setStyleSheet(spacehud.input_style)

spacehud.settings_container:hide()

updateHud()
spacehud.container:hide()