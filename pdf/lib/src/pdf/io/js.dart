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

import 'package:archive/archive.dart';

import '../format/object_base.dart';

/// Zip compression function
DeflateCallback defaultDeflate = const ZLibEncoder().encode;

/// The dart:html implementation of [pdfCompute].
@pragma('dart2js:tryInline')
Future<R> pdfCompute<R>(Future<R> Function() computation) async {
  await null;
  return computation();
}
