# gl-sdk-action
使用教程请参考以下链接
https://forum.gl-inet.cn/forum.php?mod=viewthread&tid=539&extra=page%3D1

**Translated content from link above:**

In order to help you compile plug-ins, I made a plug-in library based on github action, which can help you automatically compile the plug-ins you need.
Currently supported models:
AX1800
AXT1800
MT2500
MT3000
SF1200
SFT1200

Preconditions:
1. You must register a github account yourself
2. The github account needs to enable action. To enable action, please refer to the official github documentation.

Action warehouse link:
https://github.com/luochongjun/gl-sdk-action

Usage tutorial:
1. Fork my x project to my own warehouse



2. After forking, it will automatically switch to your own warehouse.
. Switch to the Action page
. Select set_variable workflow
. Click the run workflow button . Select the target device to be compiled
   . In the drop-down input box source code URL, fill in the source code address of the plug-in that needs to be compiled ( Be careful to use https, do not use ssh , example: https://github.com/luochongjun/edgerouter.git ）
   . In the drop-down input box Openwrt package name, fill in the name of the plug-in that needs to be compiled (the name of the plug-in to be compiled, for example: edgerouter)
. If the source code requires authentication information, you can enter your email and password. If not, leave it blank.
. Click Run workflow


3. Next, compilation will be performed automatically. The compilation time may be as fast as 2 or 3 minutes, depending on the compilation time of the plug-in itself.


4. After the compilation is completed, click on the corresponding job to view the compiled plug-in compressed package. The compressed package contains the plug-in you need to compile and all dependent software packages.

After downloading and unzipping, find the required ipk file


5. Transfer the ipk file to the router backend and use the opkg command to install it.
update record
2022-11-18 update: Support MT2500
2023-02-03 update: Support MT3000, AX1800
