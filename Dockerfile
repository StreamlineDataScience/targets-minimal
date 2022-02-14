FROM us-docker.pkg.dev/streamline-resources/streamline-private-repo/renv-base-4.1.2
LABEL maintainer="jupyter"
RUN apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-client build-essential git-core || true
RUN ["mkdir", "-m", "700", "-p", "/root/.ssh/"]
COPY [".ssh/*", "/root/.ssh/"]
RUN eval $(ssh-agent) && chmod 600 /root/.ssh/id_rsa && echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && ssh-add /root/.ssh/id_rsa
RUN ["git", "config", "--global", "user.name", "googleCloudRunner"]
RUN ["git", "config", "--global", "user.email", "cr_buildstep_gitsetup@googleCloudRunner.com"]
WORKDIR ./
COPY ["renv.lock", "./renv.lock"]
RUN R -e "renv::restore(lockfile = 'renv.lock', clean = TRUE, prompt = FALSE)"
RUN ["rm", "-rf", "/root/.ssh/*"]
CMD ["R"]
