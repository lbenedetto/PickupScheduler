class Date extends DateTime {
  static const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

  Date(int year, int month, int day) : super(year, month, day);

  Date.fromDateTime(DateTime d) : super(d.year, d.month, d.day);

  int asInt() {
    return (this.year * 10000) + (this.month * 100) + this.day;
  }

  String asString() {
    return "${months[this.month - 1]} ${this.day}";
  }

  String monthString() => months[this.month - 1];

  operator ==(other) {
    if (other is Date) {
      return this.asInt() == other.asInt();
    }
    return false;
  }

  operator <(other) {
    if (other is Date) {
      return this.asInt() < other.asInt();
    }
    return false;
  }

  operator >(other) {
    return !(this <= other);
  }

  operator <=(other) {
    return this < other || this == other;
  }

  operator >=(other) {
    return !(this < other);
  }

  int get hashCode => asInt();

  DateTime asDateTime() {
    return new DateTime(this.year, this.month, this.day);
  }

  Date increment(Duration offset){
  	return new Date.fromDateTime(this.add(offset));
  }
}
