String getDayofWeekFromDate(String dateString) {
  try {
    DateTime dateTime = DateTime.parse(dateString);
    int weekday = dateTime.weekday;

    List<String> dayOfWeek = ['一', '二', '三', '四', '五', '六', '日'];

    return "周${dayOfWeek[weekday - 1]}";
  } catch (e) {
    return "";
  }
}
