iRepEmulator
============

iRepEmulator is an iPad application that emulates Veeva iRep.  It will hit a server with your live content on it for testing in a full screen web browser with Veeva UI emulation and provide slide navigation without any modification to existing code.  It does not support Veeva iRep API methods.

Features
--------
* Looks and feels like iRep.  Includes a full screen web browser on the iPad with traditional controls positioned correctly.  
* Automatically loads "key messages" based on your existing directory structure (for info more see How to Use this Tool).
* Supports swipe navigation between key messages.  This can be turned on or off.
* Allows you to develop and test quickly, without deploying anything through the portal.

How to Use this Tool
--------------------

Take your iRep content and make it available on a web server*.   Your file structure should include a folder for each key message with an HTML file named the same as its containing folder.  You can optionally include a thumbnail file named [folder]-thumb.png.  Note that this is the folder structure that iRep requires for Key Messages so it is likely your directory is already structured in this way.  Below is an example directory structure:

	RootFolder
		|-- KeyMessageFolder1
	 		|-- KeyMessageFolder1.html
	 		|-- KeyMessageFolder1-thumb.png
 		|-- KeyMessageFolder2
	 		|-- KeyMessageFolder2.html
	 		|-- KeyMessageFolder2-thumb.png

If there is no index file at the RootFolder level, an Apache server should return a directory listing (unless it is turned off on your web server).  iRepEmulator will recognize the directory listing and ask if you want to parse it for Key Messages.  If you select the Parse option, iRepEmulator will build the film strip navigation for you and allow you to enable swiping between Key Messages.

After your content is up and running on your web server, open the app on your iPad and select the action button in the top left corner.  From here you can select the "Server Settings" option and point the URL to your web server.  The emulator will take care of the rest.

\* It is recommended that you use a local web server (WAMP or MAMP) for testing your content.  This protects the content by not publishing it to the open web and allows you to make modifications to files on the fly and hit refresh to easily view changes.

Legal
-----
*I am in no way affiliated with Veeva Systems.  All trademarks are copyrights of their respective owners.*

This software is available under the open source Apache 2.0 License.  For full license information see the LICENSE file that should have been bundled with this software.