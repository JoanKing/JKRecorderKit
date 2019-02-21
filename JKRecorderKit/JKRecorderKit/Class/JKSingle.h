

#define jkSingleH(name) +(instancetype)share##name;

#define jkSingleM(name)  \
static id instanceMessages;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
\
static dispatch_once_t onceToken;\
\
dispatch_once(&onceToken, ^{\
\
instanceMessages = [super allocWithZone:zone];\
\
});\
\
return instanceMessages;\
}\
-(id)copy\
{\
return instanceMessages;\
}\
+(instancetype)share##name\
{\
    \
    static dispatch_once_t onceToken;\
    \
    dispatch_once(&onceToken, ^{\
        \
        instanceMessages = [[self alloc]init];\
        \
    });\
    \
    return instanceMessages;\
}



