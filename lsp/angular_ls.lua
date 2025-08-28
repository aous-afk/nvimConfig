vim.lsp.config.angularls = {
   cmd = { "ngserver", "--stdio", "--tsProbeLocations", "/home/ad/.local/share/nvim/mason/packages/angular-language-server/node_modules,/home/ad/ipsyscon-workspace/planung/planung-xq-frontend/node_modules", "--ngProbeLocations", "/home/ad/.local/share/nvim/mason/packages/angular-language-server/node_modules/@angular/language-server/node_modules,/home/ad/ipsyscon-workspace/planung/planung-xq-frontend/node_modules/@angular/language-server/node_modules", "--angularCoreVersion", "19.2.6" },
   filetypes = {"typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular"},
  root_markers= {"angular.json", "nx.json"},
}

