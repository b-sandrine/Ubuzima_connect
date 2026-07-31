import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../domain/entities/patient_timeline.dart';
import '../../domain/entities/timeline_event.dart';
import 'event_category_style.dart';

/// DOC-04's "Export PDF" action — renders the patient header and the
/// currently visible timeline (respecting the active filter/search, same as
/// what's on screen) into a PDF and hands it to the platform's print/save
/// dialog via `printing`.
Future<void> exportTimelinePdf({
  required PatientTimeline timeline,
  required List<TimelineEvent> events,
}) async {
  final doc = pw.Document();

  doc.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Header(
          level: 0,
          child: pw.Text(
            timeline.patient.name,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Text(timeline.patient.summary),
        pw.Text('Criticality: ${timeline.patient.criticality}'),
        pw.SizedBox(height: 16),
        pw.Text(
          'Event Timeline',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          columnWidths: const {
            0: pw.FlexColumnWidth(1.4),
            1: pw.FlexColumnWidth(1.4),
            2: pw.FlexColumnWidth(2.4),
            3: pw.FlexColumnWidth(3.8),
          },
          children: [
            pw.TableRow(
              children: [
                _cell('Date', bold: true),
                _cell('Category', bold: true),
                _cell('Event', bold: true),
                _cell('Detail', bold: true),
              ],
            ),
            for (final event in events)
              pw.TableRow(
                children: [
                  _cell(event.dateLabel),
                  _cell(EventCategoryStyle.of(event.category).label),
                  _cell(event.title),
                  _cell(event.detail),
                ],
              ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Text(
          'AI Analysis (${timeline.aiViewLabel})',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(timeline.aiSummary),
      ],
    ),
  );

  await Printing.layoutPdf(onLayout: (_) => doc.save());
}

pw.Widget _cell(String text, {bool bold = false}) => pw.Padding(
  padding: const pw.EdgeInsets.all(4),
  child: pw.Text(
    text,
    style: pw.TextStyle(
      fontSize: 9,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
    ),
  ),
);
