/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:typed_data';

import 'ascii85.dart';
import 'base.dart';
import 'dict.dart';
import 'name.dart';
import 'num.dart';
import 'object_base.dart';
import 'stream.dart';

class PdfDictStream extends PdfDict<PdfDataType> {
  PdfDictStream({
    Map<String, PdfDataType>? values,
    Uint8List? data,
    this.isBinary = false,
    this.encrypt = true,
    this.compress = true,
  })  : data = data ?? Uint8List(0),
        super.values(values ?? {});

  @Deprecated('Use PdfDictStream() instead')
  PdfDictStream.values({
    required Map<String, PdfDataType> values,
    required this.data,
    this.isBinary = false,
    this.encrypt = true,
    this.compress = true,
  }) : super.values(values);

  Uint8List data;

  final bool isBinary;

  final bool encrypt;

  final bool compress;

  @override
  void output(PdfObjectBase o, PdfStream s, [int? indent]) {
    final values = PdfDict(this.values);

    Uint8List? data;

    if (values.containsKey('/Filter')) {
      // The data is already in the right format
      data = data;
    } else if (compress && o.settings.deflate != null) {
      // Compress the data
      final newData = Uint8List.fromList(o.settings.deflate!(this.data));
      if (newData.lengthInBytes < this.data.lengthInBytes) {
        values['/Filter'] = const PdfName('/FlateDecode');
        data = newData;
      }
    }

    if (data == null) {
      if (isBinary) {
        // This is an Ascii85 stream
        final e = Ascii85Encoder();
        data = e.convert(this.data);
        values['/Filter'] = const PdfName('/ASCII85Decode');
      } else {
        // This is a non-deflated stream
        data = data;
      }
    }

    if (encrypt && o.settings.encryptCallback != null) {
      data = o.settings.encryptCallback!(this.data, o);
    }

    values['/Length'] = PdfNum(this.data.length);

    values.output(o, s, indent);
    if (indent != null) {
      s.putByte(0x0a);
    }
    s.putString('stream\n');
    s.putBytes(this.data);
    s.putString('\nendstream');
  }
}
