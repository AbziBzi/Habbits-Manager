extension ConvertBool on bool {
  int toInt() {
    if (this == true)
      return 1;
    else
      return 0;
  }
}

extension ConvertInt on int {
  bool toBool() {
    if (this == 1)
      return true;
    else
      return false;
  }
}
