## Installation

If `bash` isn't your default shell and you want it to be:

```
sudo chsh -s /bin/bash $(whoami)
```

One-liner install:
``
(mkdir -p /tmp/laptop && cd /tmp/laptop && curl -L https://github.com/jshafton/laptop/archive/master.tar.gz | tar zx --strip 1 && sh ./update.sh)
``
