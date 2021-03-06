// Generated by Apple Swift version 4.1 effective-3.3 (swiftlang-902.0.48 clang-902.0.37.1)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR __attribute__((enum_extensibility(open)))
# else
#  define SWIFT_ENUM_ATTR
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
@import UIKit;
@import CoreGraphics;
@import Foundation;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="WSTagsField",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

@class UIFont;
@class UIColor;
@class NSCoder;
@class UITapGestureRecognizer;

SWIFT_CLASS("_TtC11WSTagsField9WSTagView")
@interface WSTagView : UIView
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly) CGFloat xPadding;)
+ (CGFloat)xPadding SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly) CGFloat yPadding;)
+ (CGFloat)yPadding SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, copy) NSString * _Nonnull displayText;
@property (nonatomic, copy) NSString * _Nonnull displayDelimiter;
@property (nonatomic, strong) UIFont * _Nullable font;
@property (nonatomic, strong) UIColor * _Null_unspecified tintColor;
@property (nonatomic, strong) UIColor * _Nullable selectedColor;
@property (nonatomic, strong) UIColor * _Nullable textColor;
@property (nonatomic, strong) UIColor * _Nullable selectedTextColor;
@property (nonatomic, copy) void (^ _Nullable onDidRequestDelete)(WSTagView * _Nonnull, NSString * _Nullable);
@property (nonatomic, copy) void (^ _Nullable onDidRequestSelection)(WSTagView * _Nonnull);
@property (nonatomic, copy) void (^ _Nullable onDidInputText)(WSTagView * _Nonnull, NSString * _Nonnull);
@property (nonatomic) BOOL selected;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)updateContentWithAnimated:(BOOL)animated;
@property (nonatomic, readonly) CGSize intrinsicContentSize;
- (CGSize)sizeThatFits:(CGSize)size SWIFT_WARN_UNUSED_RESULT;
- (CGSize)sizeToFit:(CGSize)size SWIFT_WARN_UNUSED_RESULT;
- (void)layoutSubviews;
@property (nonatomic, readonly) BOOL canBecomeFirstResponder;
- (BOOL)becomeFirstResponder SWIFT_WARN_UNUSED_RESULT;
- (BOOL)resignFirstResponder SWIFT_WARN_UNUSED_RESULT;
- (void)handleTapGestureRecognizer:(UITapGestureRecognizer * _Nonnull)sender;
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
@end


@interface WSTagView (SWIFT_EXTENSION(WSTagsField)) <UITextInputTraits>
@property (nonatomic) UITextAutocorrectionType autocorrectionType;
@end


@interface WSTagView (SWIFT_EXTENSION(WSTagsField)) <UIKeyInput>
@property (nonatomic, readonly) BOOL hasText;
- (void)insertText:(NSString * _Nonnull)text;
- (void)deleteBackward;
@end


SWIFT_CLASS("_TtC11WSTagsField11WSTagsField")
@interface WSTagsField : UIView
@property (nonatomic, strong) UIColor * _Null_unspecified tintColor;
@property (nonatomic, strong) UIColor * _Nullable textColor;
@property (nonatomic, strong) UIColor * _Nullable selectedColor;
@property (nonatomic, strong) UIColor * _Nullable selectedTextColor;
@property (nonatomic, copy) NSString * _Nullable delimiter;
@property (nonatomic, strong) UIColor * _Nullable fieldTextColor;
@property (nonatomic, copy) NSString * _Nonnull placeholder;
@property (nonatomic, strong) UIFont * _Nullable font;
@property (nonatomic) BOOL readOnly;
@property (nonatomic) UIEdgeInsets padding;
@property (nonatomic) CGFloat spaceBetweenTags;
@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (nonatomic) UITextSpellCheckingType spellCheckingType;
@property (nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property (nonatomic) UITextAutocorrectionType autocorrectionType;
@property (nonatomic) BOOL enablesReturnKeyAutomatically;
@property (nonatomic, copy) NSString * _Nullable text;
@property (nonatomic, readonly, strong) UIView * _Nullable inputAccessoryView;
@property (nonatomic, strong) UIView * _Nullable inputFieldAccessoryView;
@property (nonatomic, copy) NSArray<WSTagView *> * _Nonnull tagViews;
/// Called when the text field begins editing.
@property (nonatomic, copy) void (^ _Nullable onDidEndEditing)(WSTagsField * _Nonnull);
/// Called when the text field ends editing.
@property (nonatomic, copy) void (^ _Nullable onDidBeginEditing)(WSTagsField * _Nonnull);
/// Called when the text field should return.
@property (nonatomic, copy) BOOL (^ _Nullable onShouldReturn)(WSTagsField * _Nonnull);
/// Called when the text field text has changed. You should update your autocompleting UI based on the text supplied.
@property (nonatomic, copy) void (^ _Nullable onDidChangeText)(WSTagsField * _Nonnull, NSString * _Nullable);
/// Called when a tag has been selected.
@property (nonatomic, copy) void (^ _Nullable onDidSelectTagView)(WSTagsField * _Nonnull, WSTagView * _Nonnull);
/// Called when a tag has been unselected.
@property (nonatomic, copy) void (^ _Nullable onDidUnselectTagView)(WSTagsField * _Nonnull, WSTagView * _Nonnull);
/// Called when the user attempts to press the Return key with text partially typed.
/// @return A Tag for a match (typically the first item in the matching results),
/// or nil if the text shouldn’t be accepted.
@property (nonatomic, copy) BOOL (^ _Nullable onVerifyTag)(WSTagsField * _Nonnull, NSString * _Nonnull);
/// Called when the view has updated its own height. If you are
/// not using Autolayout, you should use this method to update the
/// frames to make sure the tag view still fits.
@property (nonatomic, copy) void (^ _Nullable onDidChangeHeightTo)(WSTagsField * _Nonnull, CGFloat);
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@property (nonatomic, readonly) CGSize intrinsicContentSize;
- (void)layoutSubviews;
/// Take the text inside of the field and make it a Tag.
- (void)acceptCurrentTextAsTag;
@property (nonatomic, readonly) BOOL isEditing;
- (void)beginEditing;
- (void)endEditing;
- (void)addTags:(NSArray<NSString *> * _Nonnull)tags;
- (void)addTag:(NSString * _Nonnull)tag;
- (void)removeTag:(NSString * _Nonnull)tag;
- (void)removeTagAtIndex:(NSInteger)index;
- (void)removeTags;
- (void)onTextFieldDidChange:(id _Nonnull)sender;
- (void)selectNextTag;
- (void)selectPrevTag;
- (void)selectTagView:(WSTagView * _Nonnull)tagView animated:(BOOL)animated;
- (void)unselectAllTagViewsAnimated:(BOOL)animated;
@end

@class UITextField;

@interface WSTagsField (SWIFT_EXTENSION(WSTagsField)) <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField * _Nonnull)textField;
- (void)textFieldDidEndEditing:(UITextField * _Nonnull)textField;
- (BOOL)textFieldShouldReturn:(UITextField * _Nonnull)textField SWIFT_WARN_UNUSED_RESULT;
- (BOOL)textField:(UITextField * _Nonnull)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString * _Nonnull)string SWIFT_WARN_UNUSED_RESULT;
@end

#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
