class Date extends DateTime {
  Date(int year, int month, int day) : super(year, month, day);

  Date.fromNow(DateTime d) : super(d.year, d.month, d.day);

  int asInt() {
    return (this.year * 10000) + (this.month * 100) + this.day;
  }

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

  DateTime getAsDateTime() {
    return new DateTime(this.year, this.month, this.day);
  }
}
