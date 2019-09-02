# Nix Configs

## Setup on macOS

First you need the nix package manager installed:
```
curl https://nixos.org/nix/install | sh
```

and initialized in your `.zshrc`:
```
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
```


Next, we need a virtual linux environment in which to build our packages, as most
builds require x86_64 gnu_linux. One option is linuxkit-nix (remember to check their
readme on github for a later version):
```
nix-env -i /nix/store/jgq3savsyyrpsxvjlrz41nx09z7r0lch-linuxkit-builder
```

Currently, linuxkit-nix installs the config to ssh into the vm in ~root. Later
versions will be smarter, but for now copy the contents of this file into your local
ssh config:
```
sudo nvim /var/root/.ssh/nix-linuxkit-ssh-config
```

Then run the following:
```
nix-linuxkit-configure
```

The vm does not always start up successfully, particularly after a reboot. You can
quickly check if it is running by trying to ssh into it:
```
ssh root@nix-linuxkit 
```

For now, if you experience trouble, the quicket solution I've found is to clear it
out and reconfigure it (hopefully the underlying error will not be present in later
versions):
```
rm -rf ~/.cache/nix-linuxkit-builder
nix-linuxkit-configure
```

## Deploying to Digital Ocean

The nixops build process will look for `NIX_REMOTE_SYSTEMS` when deciding where to
try and perform part of the build. linuxkit-nix has already initialized a file that
points to its vm, so it's easiest to point `NIX_REMOTE_SYSTEMS` to that:
```
export NIX_REMOTE_SYSTEMS="/etc/nix/machines"
```

You'll also need your auth token available in your env, or digital ocean will
reasonable not let you interact with your account:
```
export DIGITAL_OCEAN_AUTH_TOKEN='your-auth-token'
```

For easy ssh, store your ssh key in a file in the `do` directory, and name it
`adc-public-key.nix`. The file should look like this:
```
[ "your-public-key" ]
```

One last gotcha: you'll need to use the source code/unstable branch of nixops if you
want your DO instance to be initialized with the nixos 19.03 channel as default. This
is likely to change in an upcoming release.

## Once the above is done:

```
nix-env -i nixops
cd do
nixops create ./adc-server.nix -d adc-server
./setup
```

## Other gotchas

I have experienced issues initializing an ssh connection with digital ocean
immediately after the droplet is created in the setup process. This usually happens
when I've been doing a lot of deploying and destroying. I haven't yet found the
underlying cause of the issue, but for now, rebooting the system clears it up.
