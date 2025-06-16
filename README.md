# Ignition Custom Container README #

Example scripts used to create a custom ThinManager Docker container that runs the Ingition Vision Client Launcher. You may watch a video demonstration here as well: https://youtu.be/XsbWVnUKtOg.

If you are looking to containerize an HMI, but don't feel like a Linux scripting guru, please check out an easier solution using our new ThinManager FactoryTalk Optix App container, possible in ThinManager version 14.1 and FactoryTalk Optix 1.6 and newer: https://www.youtube.com/watch?v=6sgCOZ_baPA.

The following is an overview of the files included:
- **build.sh** - This is the main script that is used to modify the ThinManager Chrome Container and add the Ignition Vision Client Luancher.
- **install.sh** - This is the installer script used to add any additional software from the Ubuntu apt software respository. In our case, we add the package **menu** because it's used by the client.
- **run.sh** - Used to instantiate an instance of the container on your Unbuntu server after you have compiled a working copy. See the **Testing** section for more details.
- **start.sh** - This may be the most important script, as this script is used to launch your application automatically when it runs on a ThinManager terminal. In our case, we launch the Ignition Vision Java application using the provided Java libraries from the Ignition Vision download.
- **vision-client-launcher.json** - The specific configuration file used to point your Ignition Vision Client application to your Ignition Gateway server and launch a specific application. You may choose to export this from your test run of the container as described in the **Testing** section. You may also modify the gateway IP address and application name directly from the provided JSON file.

## Preparation ##

1. Install Docker on a Ubuntu Linux image such at 22.04 LTS using these instructions: https://docs.docker.com/engine/install/ubuntu/. Use the instructions to install a specific version of Docker. For our example, you should use the lastest version of Docker 20.10.
2. Enable Docker to be run without sudo following these steps: https://docs.docker.com/engine/install/linux-postinstall/
2. Enable experimental features for Docker by adding the following JSON blob to **/etc/docker/daemon.json**:`{ "experimental": true }`
2. Restart the Docker service with the command `systemctl restart docker.service`.
3. Download the latest ThinManager Chrome Docker container from thinmanager.com/downloads from the Container Images section.
4. Load the container image by opening a terminal in the Downloads folder and running the command `sudo docker load -i filename.tar.gz`
4. Download this repo as a .zip file and extract somewhere in your Home directory for your user.
4. Create an account, log in, and download the latest/desired version of the visionclientlauncher.tar.gz file from Inductive Automation: https://inductiveautomation.com/downloads/. You may need to use the link to see *Other operating systems and versions*. Find the one titled **Vision Client Launcher - Linux 64-bit tar** 
4. Copy the downloaded tar.gz file to the extracted folder from this repo and extract it to a folder within the repo. The folder should be named visionclientlauncher so the scripts are able to recognize it and copy the folder to the completed container image.

## Build the Container Image ##

1. Open a terminal from the extracted repo folder, or change the working directory of the terminal to the extracted repo folder.
5. Give the build.sh execute permissions with the following command: `sudo chmod +x build.sh`
6. Open build.sh in a text editor and change the name of the container image to match the exact ThinManager Chrome container image name as found when running the `sudo docker images` command. You may only need to change it to the appropriate version at the end. For example, I changed line 26 of the script which now reads **FROM thinmanager/termina_proxy_crhome:14.0.0**.
7. Replace/modify the provided vision-client-launcher.json file so it will connect to your Ignition gateway and launch your specific client application.
8. Execute build.sh in the terminal by typing `sudo ./build.sh`
9. Wait a few minutes for Docker to finish executing the build. When it is finished, the terminal should be ready to accept new input and you should see a new file in your extracted repo folder.
10. Take the completed file and install it on the ThinManager server in the ThinManager Admin Console using the *Install* tab, *Container Images* button.

## Testing ##

The best way to test a container is to run it on a terminal. You may opt to also run the container on your Ubuntu desktop and use freerdp to connect to it for troubleshooting. Here is how you can do that:
1. Execute the following command in a terminal to install freerdp, if not installed already: `sudo apt install freerdp2-x11`.
2. After a successful build of the container image, execute the **run.sh** script. This will launch an interactive terminal with the container that is useful for examining the scripts and files on the container if desired.
3. Connect to the graphical user interface using freerdp with the following command: `xfreerdp /v:localhost:3390 /u:user /p:z /cert:ignore /shell:"lxterminal"`. 

This will launch a freerdp session that shows the linux terminal which you can use to execute the startup script with the command `/startup.sh`. You should observe if your application successfully launches as expected, or if you have any issues that you need to go and fix. You can also use standard linux commands to browse directories such as `cd` and you can examine the text of files using `cat` or `vim`. To see a list of available packages at your disposal, use the command `apt list --installed`. You cannot install anything from the apt repository within a running container, all packages must be done from the **install.sh** script as you build the container image. You also are not allowed to run any commands as **sudo** within the terminal.

## Troubleshooting ##

### Error While Installing Container on ThinManager Server: invalid map<K, T> key ###
You need to run an older version of Docker if you see this message. Uninstall Docker and reinstall version 20.10.

### Error While Generating Container: "--squash" is only supported on a Docker daemon with experimental features enabled ###
Enable experimental features by adding the following JSON blob to **/etc/docker/daemon.json**:`{ "experimental": true }`
Restart the Docker service with the command `systemctl restart docker.service`.

### Container Connects and Disconnects When Running on a Terminal ###
If you container alternates between a blue and black screen, and gives the messages unable to connect at the top left, you may have an issue with your application not starting up or staying started. Check and modify your **startup.sh** script and rebuild the container image. The scripts that we generate are designed to close the application on the terminal as soon as the process that executes in the startup script terminates. If the application ends/crashes, the container will restart and attempt to launch the application again, which can give the behavior of connecting and disconnecting.


