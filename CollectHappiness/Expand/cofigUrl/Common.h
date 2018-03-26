#ifndef Common_h
#define Common_h

#ifdef DEBUG
#define LOG_D(format, vars...) NSLog(@"DEBUG " format"  <%@:%d>", ##vars, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__)
#define LOG_I(format, vars...) NSLog(@"INFO  " format"  <%@:%d>", ##vars, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__)
#define LOG_W(format, vars...) NSLog(@"WARN  " format"  <%@:%d>", ##vars, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__)
#define LOG_E(format, vars...) NSLog(@"ERROR " format"  <%@:%d>", ##vars, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__)
#else
#define LOG_D(format, vars...) ;
#define LOG_I(format, vars...) ;
#define LOG_W(format, vars...) ;
#define LOG_E(format, vars...) ;
#endif

// JSON字符串与对象(NSArray/NSDictionary)互转
#define OBJ2JSON(object) [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:object options:0 error:nil] encoding:NSUTF8StringEncoding]
#define JSON2OBJ(json)   [HelperUtil toArrayOrNSDictionary:json]

#define WEAK_SELF __weak __typeof(&*self)weakSelf = self;
#define CHECK_WEAK_SELF if (weakSelf == nil) { return; }

#define IS_EMPTY_ARRAY(array) (array == nil || array.count == 0)
#define IS_EMPTY_STRING(str) (str == nil || [@"" isEqualToString:str])

// API返回结果处理
#define RESPONSE_CODE       (data[@"success"])
#define RESPONSE_RESULT     (data[@"data"])
#define RESPONSE_MSG        (data[@"error"][@"message"] ? [NSString stringWithFormat:@"%@", data[@"error"][@"message"]] : @"")
#define RESPONSE_IS_VALID   ([RESPONSE_CODE intValue] == 0)
#define IS_API_ERROR(error) ([error isKindOfClass:ApiRequestError.class])
#ifdef DEBUG
#define RESPONSE_LOG        if RESPONSE_IS_VALID { LOG_D("%@", OBJ2JSON(data)) } else { LOG_W("[code=%@] %@", data[@"code"], RESPONSE_MSG) }
#define RESPONSE_ERROR      LOG_D("%@", error)
#else
#define RESPONSE_LOG        ;
#define RESPONSE_ERROR      ;
#endif
#define RESPONSE_SHOW_ERROR(error)  if (IS_API_ERROR(error)) { \
                                        [HUD showErrorMessage:error.domain toView:nil]; \
                                    } else { \
                                        [HUD showErrorMessage:@"您的网络不给力，请稍后再试" toView:nil]; \
                                    }

// 时间
#define ONE_SECOND      (1.0f)
#define ONE_MINUTE      (ONE_SECOND * 60.0f)
#define ONE_HOUR        (ONE_MINUTE * 60.0f)
#define ONE_DAY         (ONE_HOUR * 24)
#define ONE_WEEK        (ONE_DAY * 7)

// TableView
#define REUSABLE_CELL(tableView, identifier) ([HelperUtil dequeueReusableCellWithIdentifier:identifier forTableView:tableView])
#define DEFAULT_CELL (REUSABLE_CELL(tableView, @"DefaulCellID"))

#define GET_CURRENCY(object, key) (object[key].isEmpty ? -1 : object[key].floatValue)

#define IMAGE_PLACEHOLDER   @"AppIcon"
#define IMAGE_USER_HEADIMG  @"AppIcon"

#endif
