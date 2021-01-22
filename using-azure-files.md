# Working with files

## The problem of files
There is often the need for an application to deal with uploading files. Use cases include images for a product catalogue or thumbnails of users.
Applications generally do not store these images in a database - but merely use a database to reference an image that has been uploaded to the file system of the web server.

For container-based workloads this is no longer viable. Whilst the running container does have a file system (that is afterall where the code and HTML templates reside), any new additions to the contents of the container will be lost on a container restart. So, some other solution is needed.

## One solution
It is often not desirable to make larges changes to the code base of an existing application to accomodate this. The simplest method is to *mount* some more permanent storage into the container and to make sure the application writes to this.

Docker runtime has the ability to mount a volume into a container. This works both for Linux and for Windows containers. On a **docker run** commmand, this is using the *-v* parameter.

```
docker run -p8080:80 -v file-path:mount-point mycontainer
```

For a Windows container, an example of this could be:

```
docker run -p8080:80 -v C:\images:C:\mywebsite\files mycontainer
```

where the folder **C:\images** is mounted into the container at **C:\mywebsite\files**. In this manner, anything persisted during the use of the container into the C:\mywebsite\files will be persisted onto the host machine and therefore not lost when the container is stopped or restarted.

## Azure-based solution
Azure storage is the best destination for files. Azure storage has both blob storage and files. Either of these could be used for used for storing uploads to web sites. Looking at Web App for Containers, this supports the ability to mount Azure file shares into containers. This is a preview feature and is described here https://docs.microsoft.com/en-gb/azure/app-service/configure-connect-to-azure-storage?pivots=container-windows

### Steps
1. Create a file share
2. Move the files that you will be putting in file share elsewhere - so they are no longer included in the container build. 
3. Copy the above files into the Azure file share.
4. Mount the share in Web App for Containers
5. Use storage tools to validate that files are persisted.

## Create a file share
This can be created in the portal and must be done against a storage account.

## Move the files away from the container
If your application already has files in a folder inside the container, you will need to move these outside the container, so they are no longer part of the container build. It is usually best to move these to a folder *above* the folder with the Dockerfile, so you can later mount this folder into the container for local *docker run* sessions.

## Copy the above files into the Azure files share
The Azure portal now has a version of storage explorer built in and this may be used to copy any files needed into the Azure files share.

## Mount Share in Web App for Containers
This can either be done with some CLI or can be done in the portal.

CLI:
```
az webapp config storage-account add --resource-group <group-name> --name <app-name> --custom-id <custom-id> --storage-type AzureFiles --share-name <share-name> --account-name <storage-account-name> --access-key "<access-key>" --mount-path <mount-path-directory of form c:<directory name> >
```
In the portal:
This can be found in the app service *Configuration* section and then under *Path Mappings*
![Path Mappings](/mount-storage-web-app-overview.png)

Pressing the **+ New Azure Storage Mount** will allow you to fill in the details of the Azure files share and where it will be mounted in the container:

![Add a file mount](/mount-storage-web-app.png)

The file mount path needs to be chosen so this matches where the application code would upload files. If the original container was built with this in the path, then it would be best to remove this from the container build and then all non-static files should be uploaded to the Azure file share.

For example, if your application has a folder **images**, where most of the contents are static images, but there is a sub-folder **uploads**, then it may be best to keep the static images in the container, but to map the **uploads** folder to the Azure file share and then put any existing images in that folder.

### Validating this works correctly
The simplest way to validate that application file uploads work correctly is to perform a file upload in your application (once deployed to web app for containers) and then to use the Azure portal to inspect the contents of the file share:

![storage explorer portal](/storage-explorer-portal.png)

You can, of course, use the storage explorer application too.


## Summary
Newly created files inside a container will not survive a container restart - by design. So action need to be taken to handle file uploads. This article has shown how a *volume* may be attached to a container at development time and then later how Azure files may be used with *path mappings* in web app for containers to create a permanent destination for file uploads - all without needing to change your application code!
