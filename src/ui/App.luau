local constants = require(script.Parent.Parent.constants)
local vide = require(script.Parent.Parent.packages.vide)
local cleanup = require(script.Parent.Parent.util.cleanup)
local Button = require(script.Parent.components.Button)
local Toolbar = require(script.Parent.studio.Toolbar)
local ToolbarButton = require(script.Parent.studio.ToolbarButton)
local Widget = require(script.Parent.studio.Widget)
local theme = require(script.Parent.theme)

export type AppProps = {
  plugin: Plugin
}

local function App(props: AppProps)
  local enabled = vide.source(false)
  local count = vide.source(0)

  local toolbar = Toolbar {
    plugin = props.plugin,
    name = constants.PLUGIN_NAME
  }

  local open = ToolbarButton {
    toolbar = toolbar,
    id = "open",
    text = constants.PLUGIN_NAME,
    tooltip = `Click to toggle the {constants.PLUGIN_NAME} window`,
    icon = constants.PLUGIN_ICON_ID,
    active = enabled,
    onClick = function()
      enabled(not enabled())
    end
  }

  local widget = Widget {
    plugin = props.plugin,
    id = "main",
    title = constants.PLUGIN_NAME,
    dockState = Enum.InitialDockState.Float,
    enabled = enabled,
    floatSize = Vector2.new(400, 300),
    minSize = Vector2.new(200, 200),
    zIndexBehavior = Enum.ZIndexBehavior.Sibling,
    onClose = function()
      enabled(false)
    end,
    children = {
      vide.create "UIListLayout" {
        Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
      },

      vide.create "TextLabel" {
        Name = "Count",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        
        Text = count,
        TextColor3 = theme(Enum.StudioStyleGuideColor.MainText),
        TextSize = 64,
        Font = Enum.Font.BuilderSansMedium,
      },

      Button {
        text = "Click",
        textSize = 24,
        onClick = function()
          count(count() + 1)
        end
      }
    }
  }

  vide.effect(function()
    if count() < 10 then return end
    count(0)
    enabled(false)
  end)

  cleanup(toolbar, open, widget)
end

return App