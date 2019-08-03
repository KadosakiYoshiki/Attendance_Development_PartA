require 'csv'

CSV.generate do |csv|
  csv_column_names = %w(勤務日 出勤時間 退勤時間)
  csv << csv_column_names
  @attendances.each do |attendance|
    csv_column_values = [
      l(attendance.worked_on, format: :short),
      (l(attendance.started_at, format: :time) if attendance.started_at.present?),
      (l(attendance.finished_at, format: :time) if attendance.finished_at.present?),
    ]
    csv << csv_column_values
  end
end