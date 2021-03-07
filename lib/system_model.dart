class SystemStatus{
  final String sysStatus;

  SystemStatus({
    this.sysStatus,
  });

  factory SystemStatus.fromJson(Map<String, dynamic> json){
    return new SystemStatus(
      sysStatus: json['zop_status'],
    );
  }

}