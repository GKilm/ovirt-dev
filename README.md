# ovirt-dev
ovirt-engine development with docker for vscode in the `devcontainer` mode

# How to use

```
docker compose up -d
```

The `ovirt-dev` container is dev container.

# Setup up

In the dev container, exec `${PREFIX}/bin/engine-setup` to setup `ovirt-engine`.

# Start service

```
"${PREFIX}/share/ovirt-engine/services/ovirt-engine/ovirt-engine.py" start
```

# How to debug

For `vscode`, there are two debug configure in the `.vscode/launch.json`. One is for front, Another is for backend.

With the front debug, some knowleage of `gwt` is needed.(google web toolkit)

