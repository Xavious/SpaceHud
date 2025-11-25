-- ============================================================================
-- SpaceHud Plugin Registration
-- ============================================================================

-- Register SpaceHud with the plugin dock
function spacehud.registerPlugin()
  if not (lotj and lotj.plugin and lotj.plugin.dock and lotj.plugin.dock.register) then 
    return 
  end

  lotj.plugin.dock.register("@PKGNAME@", {
  icon = getMudletHomeDir() .. '/@PKGNAME@/spacehud_icon.png',
  hoverIcon = getMudletHomeDir() .. '/@PKGNAME@/spacehud_icon_hover.gif',
  onClick = function()
    if spacehud.container.hidden then
      spacehud.show()
    else
      spacehud.hide()
    end
  end
  })
end

spacehud.registerPlugin()

-- Register event handler to clean up when package is uninstalled
registerAnonymousEventHandler("sysUninstallPackage", function(_, packageName)
  if packageName == "@PKGNAME@" then
      spacehud.hide()
      spacehud = nil
  end
end)