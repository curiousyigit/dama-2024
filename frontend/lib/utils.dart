bool convertToBool(dynamic value) {
  if (value is bool) {
    return value;
  } else if (value is int) {
    return value == 1;
  } else if (value is String) {
    return value == "1" || value.toLowerCase() == "true";
  } else {
    return false;
  }
}