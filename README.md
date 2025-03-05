# rc.nvim

Forked from [modular kickstart.nvim](https://github.com/dam9000/kickstart-modular.nvim).

## Deploying

```sh
git clone https://github.com/JosBritton/rc.nvim.git ~/.config/nvim
```

## Requirements

- 64-bit operating system[^2]

Dependencies:

- markdownlint
- yamllint
- make[^1][^2]
- stylua
- gopls
- shellcheck
- yarn[^3]
- rust-analyzer
- clangd
- ripgrep/rg[^4]
- gcc *OR* clang[^1]
- fd[^5]

---
[^1]: For compiling native fzf C-port for telescope
[^2]: For building lua snippets
[^3]: For building markdown preview
[^4]: For telescope's grep functionality
[^5]: For telescope's find functionality
