import '../models/models.dart';

/// Mock team members keyed by farmer ID.
final Map<String, List<TeamMember>> mockTeamsByFarmer = {
  'F001': [
    TeamMember(id: 'TM001', name: 'John Smith', phone: '9876543210', role: TeamRole.owner, farmerId: 'F001', joinedDate: DateTime(2024, 3, 15)),
    TeamMember(id: 'TM002', name: 'Steven Harris', phone: '9876543221', role: TeamRole.manager, farmerId: 'F001', joinedDate: DateTime(2024, 4, 1)),
    TeamMember(id: 'TM003', name: 'Mark Evans', phone: '9876543222', role: TeamRole.staffEdit, farmerId: 'F001', joinedDate: DateTime(2024, 5, 10)),
    TeamMember(id: 'TM004', name: 'Richard Moore', phone: '9876543223', role: TeamRole.staffView, farmerId: 'F001', joinedDate: DateTime(2024, 6, 20)),
  ],
  'F002': [
    TeamMember(id: 'TM005', name: 'James Wilson', phone: '9876543212', role: TeamRole.owner, farmerId: 'F002', joinedDate: DateTime(2024, 1, 10)),
    TeamMember(id: 'TM006', name: 'Emma Watson', phone: '9876543230', role: TeamRole.manager, farmerId: 'F002', joinedDate: DateTime(2024, 2, 15)),
    TeamMember(id: 'TM007', name: 'David Lee', phone: '9876543231', role: TeamRole.staffEdit, farmerId: 'F002', joinedDate: DateTime(2024, 3, 20)),
  ],
  'F004': [
    TeamMember(id: 'TM008', name: 'Michael Brown', phone: '9876543214', role: TeamRole.owner, farmerId: 'F004', joinedDate: DateTime(2024, 2, 5)),
    TeamMember(id: 'TM009', name: 'Priya Sharma', phone: '9876543232', role: TeamRole.staffView, farmerId: 'F004', joinedDate: DateTime(2024, 7, 1)),
  ],
  'F008': [
    TeamMember(id: 'TM010', name: 'Robert Taylor', phone: '9876543218', role: TeamRole.owner, farmerId: 'F008', joinedDate: DateTime(2023, 11, 1)),
    TeamMember(id: 'TM011', name: 'Daniel Mitchell', phone: '9876543233', role: TeamRole.manager, farmerId: 'F008', joinedDate: DateTime(2024, 1, 5)),
    TeamMember(id: 'TM012', name: 'Anita Verma', phone: '9876543234', role: TeamRole.staffEdit, farmerId: 'F008', joinedDate: DateTime(2024, 3, 15)),
    TeamMember(id: 'TM013', name: 'Rahul Patel', phone: '9876543235', role: TeamRole.staffView, farmerId: 'F008', joinedDate: DateTime(2024, 4, 10)),
    TeamMember(id: 'TM014', name: 'Sneha Reddy', phone: '9876543236', role: TeamRole.staffView, farmerId: 'F008', joinedDate: DateTime(2024, 6, 1)),
  ],
};
