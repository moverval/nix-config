{
  name,
  comment,
  icon,
  exec,
  pkg,
  categories ? [ ],
}:
{
  home.packages = [
    pkg
  ];

  xdg.desktopEntries."${name}" = {
    name = name;
    comment = comment;
    exec = "${pkg}${exec}";
    icon = icon;
    categories = categories;
  };
}
