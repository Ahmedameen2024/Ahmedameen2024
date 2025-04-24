import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CustomFilePicker extends StatefulWidget {
  final ValueChanged<PlatformFile>? onFileSelected;
  final ValueChanged<String>? onError;
  final bool allowMultiple;
  final List<String>? allowedExtensions;
  final FileType fileType;
  final String buttonText;
  final IconData buttonIcon;
  final ButtonStyle? buttonStyle;
  final Widget? filePreview;

  const CustomFilePicker({
    super.key,
    this.onFileSelected,
    this.onError,
    this.allowMultiple = false,
    this.allowedExtensions,
    this.fileType = FileType.any,
    this.buttonText = 'اختر ملف',
    this.buttonIcon = Icons.attach_file,
    this.buttonStyle,
    this.filePreview,
  });

  @override
  _CustomFilePickerState createState() => _CustomFilePickerState();
}

class _CustomFilePickerState extends State<CustomFilePicker> {
  PlatformFile? _selectedFile;
  String? _fileName;
  bool _isLoading = false;

  Future<void> _pickFile() async {
    try {
      setState(() => _isLoading = true);

      final result = await FilePicker.platform.pickFiles(
        type: widget.fileType,
        allowMultiple: widget.allowMultiple,
        allowedExtensions: widget.allowedExtensions,
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          _fileName = _selectedFile!.name;
        });
        widget.onFileSelected?.call(_selectedFile!);
      }
    } catch (e) {
      widget.onError?.call('خطأ في اختيار الملف: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedFile = null;
      _fileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_fileName != null) ...[
          // const SizedBox(height: 16),

          _buildFileInfo(),
          const SizedBox(width: 16),
        ],
        _buildFilePickerButton(),
        if (widget.filePreview != null && _selectedFile != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: widget.filePreview!,
          ),
      ],
    );
  }

  Widget _buildFilePickerButton() {
    return ElevatedButton.icon(
      icon: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Icon(widget.buttonIcon),
      label: Text(_isLoading ? 'جارِ التحميل...' : widget.buttonText),
      onPressed: _isLoading ? null : _pickFile,
      style: widget.buttonStyle ??
          ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
    );
  }

  Widget _buildFileInfo() {
    return Row(
      children: [
        Text(
          _fileName!,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (_selectedFile != null)
          Text(
            'الحجم: ${(_selectedFile!.size / 1024).toStringAsFixed(2)} KB',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.blue,
                ),
          ),
        IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: _clearSelection,
          tooltip: 'مسح الاختيار',
        ),
      ],
    );
  }
}
