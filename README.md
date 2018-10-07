gitweb for readonly access of non-bare repos.

## Usage

```sh
docker run \
    -p 8080:80 \
    -v /path/to/my/git/repo1:/var/lib/git/repo1:ro \
    -v /path/to/my/git/repo2:/var/lib/git/repo2:ro \
    kostyaesmukov/gitweb-readonly
```

## Clone

```sh
git clone http://localhost:8080/repo1.git
```

## Related projects:
- https://github.com/anyakichi/docker-git-http
- https://github.com/cirocosta/gitserver-http

