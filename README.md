# Welcome

This is a pet project of mine. It is coded for windows and almost entirely made within batch script.

It takes screenshots of your screens, for your use, and does not send them to any third party. 

I have been working on this since mid 2023, way before Microsoft recall was announced almost exactly a year later. I started making this script, as I realised I desperately needed something to take screenshots for many different purposes.

Purposes I found for myself:
- Playing a game, and don't remember the name of someone you played with? Look at the screenshots.
- Want to know what website you were just on? Look at the screenshots.
- Want to see what was just shown in a meeting but don't want to ask to see it again? Or want a still of it? Look at the screenshots.
- Need to know what you did to get to a location within a webpage? Look at the screenshots.
- Need proof you uploaded an assignment at a specific time? Look at the screenshots.

I personally believe this is the most useful script I have ever made.

The only downside is that if someone else gets access to your PC, they now have the ability to see exactly what you have been doing if they know where to look. I do plan to change this in future so it's more secure, but it is difficult.

These screenshots are stored and then deleted over time depending on what settings you apply within the config.cfg file that gets generated.

The config.cfg has information as to what each setting does.

## Installation
I'll improve these instructions soon, but for now here is a rough install guide.
All you actually need is the update.bat. Drag this in to a folder named with no spaces in the name. Run the update.bat within this folder, and the app will install in this location.

## Known bugs/issues/limitations:
The script does install and keeps itself working using the task scheduler. The task scheduler by default when installing via commands has the setting where if the computer is on battery, the script will not start. This currently needs to be manually changed by you to work, but only once.

Antiviruses do not like this script. Anything that is not windows defender will likely quarantine this script in some manner. Just allow all the files that get blocked to exist if possible.

Admin privilegies are required for install.

If you have dropbox blocked somehow via your isp or your router, this script will not install.


## Credits

This script makes extensive use of the following external software. Full credit goes to their respective developers:

- **[nircmd.exe](https://www.nirsoft.net/utils/nircmd.html)**  
  Developed by Nir Sofer at [nirsoft.net](https://www.nirsoft.net), this utility is used extensively throughout the script.

- **[ImageMagick](https://imagemagick.org/)**  
  Developed by the ImageMagick Studio LLC, this powerful image processing toolkit is also heavily utilised in the script.
