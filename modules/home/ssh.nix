{ ... }:

{
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    # TODO: Enable this when switch to 24.05
    # addKeysToAgent = "yes";
  };
}
