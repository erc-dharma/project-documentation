# Help with Oxygen Editor

If you need access occasionally to another font, check first if you can find want you need in the Characters Map.
*   [Accessing the Character Map](#Accessing_the_Character_Map)

If you need a large access to another font, go check the Unicode Fallback support :
*   [Unicode Fallback support](#Unicode_Fallback_support)

## Accessing the Character Map
To insert a special character within a document
  - Open the Character Map dialog box from `Edit` > `Insert from Character Map`
  - Find the symbol you want to insert and double-click it (or select it and click Insert).

## Unicode Fallback support
Oxygen provides fonts covering most common Unicode. However, if you want to use special symbols or characters like grantha, those are not included in default fonts. Your display will be small rectangles then. *Fallback* font works a reserve. When the editor find any special character, it will find it in the fallback.

### Adding a fallback for Windows
We need to install a fallback font inside the Oxygen XML editor installation directory
   - Start Windows Explorer
   - Go to _[OXYGEN_INSTALL_DIR]_/jre/lib/fonts directory
   - If no folder called `fallback` exist, create a new folder `fallback`
   - Copy a font file into the directory. It needs to have .ttf extension
   - Restart Oxygen XML Editor

  Sometimes, it doesn't take effect automatically, then open the dialog box `Options` > `Preferences...`. In the left panel, select `Appearance` then `Fonts`. Click on `Restore Defaults` at the bottom of the right panel.

### Adding a fallback for others platforms
For Mac OS X or other platforms, you need to create a custom font in .ttf format.
   - Use a font editor (such as FontForge) to combine multiple fonts into a single custom font.
   - Install the font file into the dedicated font folder of your system.
   - Open the dialog box `Options` > `Preferences...`. In the left panel, select `Appearance` then `Fonts`. Click on `Restore Defaults` at the bottom of the right panel.
   - Click the `Choose` button for Editor and select your custom font from the drop-down list in the dialog box.
   - Restart Oxygen XML Editor

### Special fonts
Some fonts chosen by each task force are available in the folder.

**For TFA**:
- NotoSansTamil-Regular.ttf
- NotoSansGrantha-Regular.ttf
- e-VatteluttuOT.ttf
