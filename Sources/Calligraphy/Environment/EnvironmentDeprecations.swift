// Calligraphy
// EnvironmentDeprecations.swift
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

/// The former name of ``EnvironmentValues``.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@available(*, deprecated, renamed: "EnvironmentValues", message: "Use EnvironmentValues instead")
public typealias StringEnvironmentValues = EnvironmentValues

/// The former name of ``EnvironmentKey``.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@available(*, deprecated, renamed: "EnvironmentKey", message: "Use EnvironmentKey instead")
public typealias StringEnvironmentKey = EnvironmentKey

/// The former name of ``Environment``.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@available(*, deprecated, renamed: "Environment", message: "Use Environment instead")
public typealias StringEnvironment<Value> = Environment<Value>

/// The former name of ``Entry()``.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@available(*, deprecated, renamed: "Entry", message: "Use @Entry instead")
@attached(accessor)
@attached(peer, names: prefixed(__Key_))
public macro StringEntry() = #externalMacro(
    module: "CalligraphyCompilerPlugin",
    type: "EntryMacro"
)
