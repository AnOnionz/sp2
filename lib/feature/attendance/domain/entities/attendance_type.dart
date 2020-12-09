class AttendanceType {
  final int index;
  final String name;
  final String value;

  AttendanceType(this.index, this.name, this.value);
}
class CheckIn extends AttendanceType{
    CheckIn(): super(1, "chấm công vào", "CHECK_IN");

}
class CheckOut extends AttendanceType{
    CheckOut(): super(2, "chấm công ra", "CHECK_OUT");
}
