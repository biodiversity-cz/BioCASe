# BioCASe
Docker images of the BioCASe software, see the **Packages** on the right.

To be capable run [BioCASe](https://www.biocase.org/) in [CERIT Scientific Cloud](https://www.cerit-sc.cz/), we need a *no root* image with exact versioning and security updates. To achieve this, we modify official [Dockerfile](hhttps://git.bgbm.org/biocase/bps/-/blob/master/Dockerfile?ref_type=heads) and produce versioned images as an alternative to the [official](https://hub.docker.com/r/biocase/bps).

The base image is checked [once per week](.github/dependabot.yml#L6) for updates and all [included versions](.github/workflows/publish.yml#L15) of BioCASe are rebuild.

Functional differences against the official version
* no root in container
* exposing app directly on :80 without the /biocase subpath
* add /opt/biocase/config-initial (copy of config) as a source for copying into volumeMount when deployed on Kubernetes

[//]: # (obligatory branding for EOSC.CZ)
<hr style="margin-top: 100px; margin-bottom: 20px">

<p style="text-align: left"> <img src="https://webcentrum.muni.cz/media/3831863/seda_eosc.png" alt="EOSC CZ Logo" height="90"> </p>
This project output was developed with financial contributions from the EOSC CZ initiative throught the project National Repository Platform for Research Data (CZ.02.01.01/00/23_014/0008787) funded by Programme Johannes Amos Comenius (P JAC) of the Ministry of Education, Youth and Sports of the Czech Republic (MEYS).

<p style="text-align: left"> <img src="https://webcentrum.muni.cz/media/3832168/seda_eu-msmt_eng.png" alt="EU and MŠMT Logos" height="90"> </p>
