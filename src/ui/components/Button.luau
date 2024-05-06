local vide = require(script.Parent.Parent.Parent.packages.vide)
local types = require(script.Parent.Parent.Parent.types)
local useColor = require(script.Parent.Parent.Parent.util.useColor)
local theme = require(script.Parent.Parent.theme)

export type ButtonProps = {
  text: types.SourcedAs<string>,
  textSize: types.SourcedAs<number>?,
  buttonColor: Enum.StudioStyleGuideColor?,
  onClick: () -> ()?
}

local function Button(props: ButtonProps): TextButton
  local hovering = vide.source(false)
  local pressed = vide.source(false)

  return vide.create "TextButton" {
    Name = "Button",
    BackgroundColor3 = vide.spring(useColor(props.buttonColor or Enum.StudioStyleGuideColor.Button, {
      hovering = hovering,
      pressing = pressed,
    }), .15),
    Size = UDim2.fromScale(0, 0),
    AutomaticSize = Enum.AutomaticSize.XY,

    Text = vide.read(props.text),
    TextColor3 = theme(Enum.StudioStyleGuideColor.MainText),
    TextSize = vide.read(props.textSize or 18),
    Font = Enum.Font.BuilderSansMedium,

    MouseEnter = function()
      hovering(true)
    end,

    MouseLeave = function()
      hovering(false)
      pressed(false)
    end,

    MouseButton1Down = function()
      pressed(true)
    end,

    MouseButton1Up = function()
      pressed(false)
    end,

    Activated = props.onClick or function() end,

    vide.create "UIPadding" {
      PaddingLeft = UDim.new(0, 8),
      PaddingRight = UDim.new(0, 8),
      PaddingTop = UDim.new(0, 4),
      PaddingBottom = UDim.new(0, 4),
    },

    vide.create "UICorner" {
      CornerRadius = UDim.new(0, 4),
    }
  }
end

return Button