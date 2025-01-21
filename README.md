# BioCASe
Docker images of the BioCASe software, see the **Packages** on the right.

To be capable run BioCASe in [CERIT Scientific Cloud](https://www.cerit-sc.cz/), we need a *no root* image with exact versioning and security updates. To achieve this, we modify official [Dockerfile](http://ww2.biocase.org/svn/bps2/branches/stable/Dockerfile) and produce versioned images similar to the [official](https://hub.docker.com/r/biocase/bps).

The base image is checked [once per week](.github/dependabot.yml#L6) for updates and all [included versions](.github/workflows/publish.yml#L16) of BioCASe are rebuild.

Functional differences against the official version
* no root in image
* exposing app directly on :80 without the /biocase subpath