# Tutorial and references to create a pot/po file
- The godot gettext page : https://docs.godotengine.org/fr/stable/tutorials/i18n/localization_using_gettext.html
- A gettext quickstart guide : https://www.labri.fr/perso/fleury/posts/programming/a-quick-gettext-tutorial.html

# Commands to generate the .po file
- `msginit --input=<input_file>.pot --locale=<language (en or fr for instance)> --output=<output_file>`

# Check differences between pot files
- I made a small python program that checks all the keys in all the files in the pot folder, simply execute it, and the missing keys will appear in the summary (if none, it's all good)