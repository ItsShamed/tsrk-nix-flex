let
  files = [
    "hosts/ren/secrets/wg-home-pkey.age"
    "hosts/ren/secrets/wg-tsrk-small1-pkey.age"
  ];

  keys = [
    # Me
    # TODO: 2026-08-13: Can be removed, or even better, migrate to agenix-rekey
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINqKG1hRtbiN+ChXAwKqpHxlyCdFQdOSo8IfsUgi8Qh6"
    # Akemi Homura
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPL8iPsWQkF5FLBzr6q5MlLWkUCTskIhelkSkKeTJC16 cardno:33_753_805"
    # EPITA
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhh6BD0ihbMfWodFYBr5GBo/B/ZvDp5QqWQPAzGozM3"

    # Taku RSA
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC92FeMZh5bLaXKdBmQiyi0r3aL8BS14Vyzn1xr1p4D26jgFmRcBI8zBeDvOH804IBKTibWITWezdFR6omm93pLiY4b41BUmZXOBuuUcZrUG1vX/FdoIWDqLOvw7YeJ81+eBGRp0gCB/gK+pGHE7uPawR7quAjCJ/VzdzreCI1pC+3CYXMl15xbeS9JVZCEZNeFmkFkaL6eChnujOIVP+/h+o1Dx2t0MOJGakoL0TDtMBpRdr0RFvNCoYg3NIBPLPAB70CFr1L05F1tSQ4otHqISvei8TbIv5lnTHZik/I6pZkGEDGPwM2HMTQlPtKcfkn3gzoVFQj1SFhPFvmQVkdNwZLyKhCvd3SLXbdVSHwAeyEUqNdu9NejqDYRXmV5UAvkDB7alRYmSByiyHMfpOT7JiD8i4EcHleOYD1ewvtyTRrU0v49VASvC1kEC7w1NuiIPYTVMfjuHd7PiDRCi4coiUNNrAdMBOdZfk+rS+yamXO+zDRqBwrsoQqkBtJebdFA51BO9pKGvW7PcTa1jdw37q+SQJ1+dnuykxP/8iVLrGV+TcE7NKie9IYb+FmyaoA9sL4gLRJ/n0jW84ox0m9ky5J2HJX/0bJm2wXVb8XjX+amOGZos9EW4zMZz0AHe0WEMr0GJCKZFpHcyAkIo7jjoV6EMhwV98Dhrtw7bhjaKQ== root@tsrk-taku"
    # Taku ED25519
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjvohiv+m02lrcrSccNsz0cKFQSc1HIkanG5jiChlvu root@tsrk-taku"
    # Ren RSA
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDf8wOdsrxnpu4XL35feNCWh08x4iqmVbNjUiaDelyMdeVwh0yEYdJ17tR8ueK08sj01cw1yJvKm+EQSqOAYA7jLYV7BVEMfD3Q9h7MPlNIIsZka7JvJaMoNoAOGzf8q2s7RzS0wMO8a2PajB4J+QVDMU2UZ31jhnZhy82riTbWzM0/NOENyQbDJDcc7SOmyjrlxtTMl3rCYunuOIuO9jaiNaOsUHFJzNUeeP5gjIxKPvTRBWlbSQEFnKtX5K5VTbV1aKo8yRoLiwE3l8Rbwkk0geLv2kD2c448fsxU+HAVBBtUixqAkeW5HwBGRAn9C60hg6B0V7cQ3C7oqjj5oPL/A3Qzjt4rruDU77WVhFn/4rHfNeAVHvEMBVXqN1oLTVFt4bq7FM+wrc6HKiUtXcjpsj2Q1vnsqwSpTKc+v2yq9vl4XgZK2cMj/vvj9C1oFokpJnm1BZLAovU1o++SXl3nTGEaq40SyQaqffen+eBGgzoEuiaVv/jmX3yf6e12580XNdXrjX92t2d+OFrkgjdplVyVSnZxYcyX/aWgeXhV+/sj6rIm3NdmHO8ClQaI9xeuDLCgj+5/i5Yr4pvkoRWUV1kDEx2ITqQbK3fn1SjH39CX5jMb34gWQ6HOdUxFFK7fd1GeCAnXC06wQRFjNHbLYTQwNqPm3H/hAnZPexYow== root@tsrk-ren"
    # Ren ED25519
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGsBICS3Aup5pBsT+nTj3HbdUIEtdneO1itAnEB8mWN/ root@tsrk-ren"
    # Bootstrap
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPTlVi+8HkfmggcmApPoL7rObyCUe+8lY8L7ufCZ1FVo tsrk-bootstrap"
  ];
in builtins.listToAttrs (builtins.map (file: {
  name = file;
  value.publicKeys = keys;
}) files)
