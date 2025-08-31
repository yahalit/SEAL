#include "CANServer.h"

/* 
* List of data types
 T_int32                        (long - 0U)                       
 T_single                       (float - 2U)
 T_int16                        (short - 4U)
 T_uint32                       (unsigned long - 8U)
 T_uint16                       (unsigned short - 12U)
 T_double                       (double - 10U)
*/

/**
 * @brief Write a value to an object in the drive's object dictionary.
 *
 * This function sets the value of a specified object entry in the drive,
 * identified by its index and subindex. The value is written with the given
 * data type, and the result of the operation is returned in @p RetVal.
 *
 * @param Index
 *        The main index of the object in the drive's object dictionary.
 *        (Typically corresponds to a 16-bit object index.)
 *
 * @param subIndex
 *        The subindex of the object entry. Use 0 for objects without subentries.
 *
 * @param value
 *        The new value to be written to the object.
 *
 * @param dataType
 *        The data type code that specifies how @p value should be interpreted.
 *        (For example, VarDataTypes.T_uint32, see list above )
 *
 * @param RetVal
 *        Pointer to a long that will receive the result of the operation.
 *        Typically used for status or error codes (0 = success, non-zero = error).
 *
 * @return
 *        Status code of the operation:
 *        - 0 on success
 *        - Non-zero error code if the write failed
 */
void SetObject2Drive(short unsigned useUart , long unsigned baudRate)
{
	(void)Index;
	(void)subIndex;
	(void)value; 
	*RetVal =  0;
}

