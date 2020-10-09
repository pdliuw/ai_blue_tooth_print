/*!
 *  \~chinese
 *  @header     GrayLevel.h
 *  @abstract   图片的灰度处理
 *
 *  \~english
 *  @header     GrayLevel.h
 *  @abstract   Image gray manager
 */

#import "PTBitmap.h"
#import <UIKit/UIKit.h>

@interface PTBitmap (GrayLevel)

/*!
*  \~chinese
*  获取图像的灰度数据, gray = red*0.29891 + green*0.58661 + blue*0.11448
*
*  @param image    输入数据
*  @return         灰度数据，每个字节代表每个像素的256阶灰度值
*
*  \~english
*  Get grayscale data of image , gray = red*0.29891 + green*0.58661 + blue*0.11448
*
*  @param image    Input data
*  @return         Grayscale data, each byte indicates 256-level grayscale value of each pixel
*/
+ (NSData *)graylevel256Datas:(UIImage *)image;

/*!
 *  \~chinese
 *  获取图像的灰度数据, gray = red*0.29891 + green*0.58661 + blue*0.11448
 *
 *  @param image        图片
 *  @param needReverse  是否反转灰度值 0->255 254->1
 *  @return             灰度数据，每个字节代表每个像素的256阶灰度值
 *
 *  \~english
 *  Get grayscale data of image , gray = red*0.29891 + green*0.58661 + blue*0.11448
 *
 *  @param image        Image
 *  @param needReverse  Whether to invert the gray value
 *  @return             Grayscale data, each byte indicates 256-level grayscale value of each pixel
 */
+ (NSData *)graylevel256Datas:(CGImageRef)image reverse:(BOOL)needReverse;

/*!
 *  \~chinese
 *  从灰度图片数据获取图像
 *
 *  @param data     灰度数据，每个字节代表每个像素的256阶灰度值
 *  @param width    图片宽度
 *  @return         图片
 *
 *  \~english
 *  Get image from grayscale photo
 *
 *  @param data     Grayscale data, each byte indicates 256-level grayscale value of each pixel
 *  @param width    Image width
 *  @return         Image
 */
+ (UIImage *)imageWithGraylevel256Data:(NSData *)data width:(NSUInteger)width;

/*!
 *  \~chinese
 *  灰度数据锐化
 *
 *  @param data     灰度数据，每个字节代表每个像素的256阶灰度值
 *  @param width    图片宽度
 *  @return         经过锐化的256阶灰度数据
 *
 *  \~english
 *  grayscale data sharpen
 *
 *  @param data     Grayscale data, each byte indicates 256-level grayscale value of each pixel
 *  @param width    Image width
 *  @return         Sharpening 256-level grayscale data
 */
+ (NSData *)sharpenGraylevel256Data:(NSData *)data width:(NSUInteger)width;

/*!
 *  \~chinese
 *  获取经过热补偿处理的数据
 *
 *  @param data     灰度数据，每个字节代表每个像素的256阶灰度值
 *  @param width    图片宽度
 *  @return         处理结果数据
 *
 *  \~english
 *  Get the data with thermal compensation processing
 *
 *  @param data     Grayscale data, each byte indicates 256-level grayscale value of each pixel
 *  @param width    Image width
 *  @return         Data of processing result
 */
+ (NSData *)historyCompensateGraylevel256Data:(NSData *)data width:(NSUInteger)width;

/*!
 *  \~chinese
 *  返回黑白图像数据
 *
 *  @param data     灰度数据，每个字节代表每个像素的256阶灰度值
 *  @param width    图片宽度
 *  @return         黑白图像数据，每个字节代表一个像素，每个字节的值为0或255，0黑色 255白色
 *
 *  \~english
 *  return to the data of black and white image
 *
 *  @param data     Grayscale data, each byte indicates 256-level grayscale value of each pixel
 *  @param width    Image width
 *  @return         Data of black and white image, each byte indicates one pixel, the value of each byte is 0 or 255, 0 is black, 255 is white
 */
+ (NSData *)binaryDataOneBytePerPixelGraylevel256Data:(NSData *)data width:(NSUInteger)width;

/*!
 *  \~chinese
 *  将图片导入设备灰度空间获取的灰度数据
 *
 *  @param image    图片
 *  @return         灰度数据，每个字节代表每个像素的256阶灰度值
 *
 *  \~english
 *  Grayscale data obtained by importing image into the device grayscale space
 *
 *  @param image    Image
 *  @return         Grayscale data, each byte indicates 256-level grayscale value of each pixel
 */
+ (NSData *)systemGraylevel256Datas:(UIImage *)image;

/*!
 *  \~chinese
 *  将bitmap数据转成图片
 *
 *  @param bitmap    位图数据
 *  @param height    图片高度
 *  @return          图片
 *
 *  \~english
 *  Convert bitmap data to image
 *
 *  @param bitmap    Bitmap data
 *  @param height    Image height
 *  @return          Image
 */
+ (UIImage *)image:(NSData *)bitmap height:(size_t)height;


/*!
 *  \~chinese
 *  动态获取二值化的阈值
 *
 *  @param data         256灰阶数据
 *  @param width        图片宽度
 *  @param height       图片高度
 *  @return             阈值
 *
 *  \~english
 *  Dynamically obtaining the threshold of binarization
 *
 *  @param data         256-level grayscale data
 *  @param width        image width
 *  @param height       image height
 *  @return             threshold
 */
+ (NSUInteger)getThresholdForBinaryByGrayData:(NSData *)data width:(NSUInteger)width height:(NSUInteger)height;

/*!
 *  \~chinese
 *  获取图像的灰度数据, gray = red*0.29891 + green*0.58661 + blue*0.11448
 *
 *  @param image    输入数据
 *  @return         灰度数据，每个字节代表每个像素的256阶灰度值
 *
 *  \~english
 *  Get grayscale data of image , gray = red*0.29891 + green*0.58661 + blue*0.11448
 *
 *  @param image    Input data
 *  @return         Grayscale data, each byte indicates 256-level grayscale value of each pixel
 */
+ (NSData *)grayscaleImageForImage:(CGImageRef)image;

@end


@interface PTBitmap(Printer)

/*!
*  \~chinese
*  根据平均灰度值获取黑白处理的数据
*
*  @param data     灰度数据，每个字节代表每个像素的256阶灰度值
*  @param width    图片宽度
*  @return         处理后的数据，每一位代表一个像素，如果宽度不是8的倍数，会在右边缘加上空白点 1黑色 0白色
*
*  \~english
*  Get the data of black and white image by average grayscale
*
*  @param data     Grayscale data, each byte indicates 256-level grayscale value of each pixel
*  @param width    Image width
*  @return         Processed data, each indicates one pixel, if width is not the multiple of 8, it will add blank at the right edge, 1 is black, 0 is white
*/
+ (NSData *)binaryDataOneBitPerPixelGraylevel256Data:(NSData *)data width:(NSUInteger)width;

/*!
 *  \~chinese
 *  获取黑白处理的数据
 *
 *  @param data     灰度数据，每个字节代表每个像素的256阶灰度值
 *  @param width    图片宽度
 *  @param valve    阀值，根据这个值决定灰度值是黑色或白色,如果灰度值小于阀值，则被认为是黑色，否则白色
 *  @return         处理后的数据，每一位代表一个像素，如果宽度不是8的倍数，会在右边缘加上空白点 1黑色 0白色
 *
 *  \~english
 *  Get the data of black and white image
 *
 *  @param data     Grayscale data, each byte indicates 256-level grayscale value of each pixel
 *  @param width    Image width
 *  @param valve    Valve,determine that a grayscale pixel is black or white. if a grayscale is less than valve, the pixel is considered black,otherwise white.
 *  @return         Processed data, each indicates one pixel, if width is not the multiple of 8, it will add blank at the right edge, 1 is black, 0 is white
 */
+ (NSData *)binaryDataOneBitPerPixelGraylevel256Data:(NSData *)data width:(NSUInteger)width valve:(NSUInteger)valve;

/*!
 *  \~chinese
 *  获取抖动的图像数据
 *
 *  @param data     灰度数据，每个字节代表每个像素的256阶灰度值
 *  @param width    图片宽度
 *  @return         处理后的数据，每一位代表一个像素，如果宽度不是8的倍数，会在右边缘加上空白点 1黑色 0白色
 *
 *  \~english
 *  Get the dithering image data
 *
 *  @param data     Grayscale data, each byte indicates 256-level grayscale value of each pixel
 *  @param width    Image width
 *  @return         Processed data, each indicates one pixel, if width is not the multiple of 8, it will add blank at the right edge, 1 is black, 0 is white
 */
+ (NSData *)ditheredBinaryDataOneBitPerPixelGraylevel256Data:(NSData *)data width:(NSUInteger)width;

+ (NSData *)meiKaLePrinterData:(NSData *)graylevel256Data;

@end
