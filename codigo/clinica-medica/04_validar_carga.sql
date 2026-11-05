USE ClinicaMedica;
GO

SELECT 'Pacientes' AS Tabela, COUNT(*) AS Total FROM dbo.Pacientes
UNION ALL SELECT 'Medicos', COUNT(*) FROM dbo.Medicos
UNION ALL SELECT 'Convenios', COUNT(*) FROM dbo.Convenios
UNION ALL SELECT 'Consultas', COUNT(*) FROM dbo.Consultas
UNION ALL SELECT 'Exames', COUNT(*) FROM dbo.Exames
UNION ALL SELECT 'Pagamentos', COUNT(*) FROM dbo.Pagamentos;
GO
