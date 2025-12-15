import '../models/api_response.dart';
import '../models/clinic_models.dart';
import '../models/appointment_models.dart'; 
import '../../services/api_service.dart';

class ClinicRepository {
  final ApiService _apiService;

  ClinicRepository(this._apiService);

  Future<BaseApiResponse<List<ClinicModel>>> getClinics({int page = 1, String? search}) async {
    return await _apiService.getClinics(page: page, search: search);
  }

  Future<BaseApiResponse<List<SpecialtyModel>>> getSpecialties() async {
    return await _apiService.getSpecialties();
  }

  Future<BaseApiResponse<List<ClinicModel>>> getClinicsBySpecialty(String specialtyId, {int page = 1}) async {
    return await _apiService.getClinicsBySpecialty(specialtyId, page: page);
  }

  Future<BaseApiResponse<List<DoctorModel>>> getDoctors(String clinicId) async {
    return await _apiService.getDoctorsInClinic(clinicId);
  }

  Future<BaseApiResponse<List<SlotModel>>> getDoctorSlots(String doctorId, String date) async {
    return await _apiService.getAvailableSlots(doctorId, date);
  }

  Future<void> bookAppointment(String slotId, String reason) async {
    final request = BookingRequest(slotId: slotId, reason: reason);
    await _apiService.bookAppointment(request);
  }

  Future<BaseApiResponse<List<AppointmentModel>>> getMyPatientAppointments() async {
    return await _apiService.getMyAppointments();
  }
  
  Future<BaseApiResponse<List<AppointmentModel>>> getMyDoctorAppointments() async {
    return await _apiService.getDoctorAppointments();
  }

  Future<BaseApiResponse<List<AppointmentModel>>> getAllClinicAppointments(String clinicId) async {
    return await _apiService.getDoctorAppointments(); // Using doctor schedule as placeholder
  }
}
