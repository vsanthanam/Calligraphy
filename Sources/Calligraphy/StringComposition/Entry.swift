// Calligraphy
// Entry.swift
//
// MIT License
//
// Copyright (c) 2026 Varun Santhanam
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
//
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

/// Generate the boilerplate required to expose a property on ``StringEnvironmentValues`` as a readable environment value.
///
/// Apply `@StringEntry` to a stored property declared inside an extension on ``StringEnvironmentValues``. The macro synthesizes a private ``StringEnvironmentKey`` type and the getter/setter accessors that read from and write to the environment storage.
///
/// ```swift
/// extension StringEnvironmentValues {
///
///     @StringEntry
///     public var separator: String = "\n"
///
/// }
/// ```
///
/// Non-optional properties must provide an initial value. Optional properties may omit the initial value, in which case the default is `nil`:
///
/// ```swift
/// extension StringEnvironmentValues {
///
///     @StringEntry
///     public var prefix: String? // Default is `nil`, since `String?` is an optional and no default was provided.
///
/// }
/// ```
///
/// The expanded property can be set on any component using ``StringComponent/environment(_:_:)-(_,Value)`` or read using ``StringEnvironment``.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@attached(accessor)
@attached(peer, names: prefixed(__Key_))
public macro StringEntry() = #externalMacro(
    module: "CalligraphyCompilerPlugin",
    type: "StringEntryMacro"
)
