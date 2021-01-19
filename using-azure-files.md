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
2. Mount the share in Web App for Containers
3. Use storage tools to validate that files are persisted.

## Create a file share
This can be created in the portal and must be done against a storage account.

## Mount Share in Web App for Containers
This can either be done with some CLI or can be done in the portal.

CLI:
```
az webapp config storage-account add --resource-group <group-name> --name <app-name> --custom-id <custom-id> --storage-type AzureFiles --share-name <share-name> --account-name <storage-account-name> --access-key "<access-key>" --mount-path <mount-path-directory of form c:<directory name> >
```
In the portal:
This can be found in the app service *Configuration* section and then under *Path Mappings*



