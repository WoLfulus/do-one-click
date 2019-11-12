# Directus Snapshot

**NOTE: DO NOT USE THIS DIRECTLY**

This script will generate a snapshot which in turn is being distributed through the DigitalOcean Marketplace. This repo **can not be used directly**.

This project creates a Directus snapshot on DigitalOcean containing a LAMP stack preconfigured with Directus. Once a droplet is created from the snapshot (or using the marketplace), the MySQL server is configure and on login, a quick MOTD will give all the information the user needs to continue the setup from directus admin panel.

# Building

To build a snapshot, create a `.env` file containing a `DIGITALOCEAN_API_TOKEN` variable with your DigitalOcean API token. This is required to gain access to DO api of your account.

Then make sure you have `bash` and `packer` installed, then run the build script in `./bin/build`. The latest version of directus will be fetched automatically, but if you want to build a snapshot for a specific version, you can pass `--version` argument to the build script. For example `./bin/build --version 20191112A`.

After the build is done, a snapshot will be available on your DigitalOcean account.
