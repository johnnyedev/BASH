def is_prime(number):
    # Input number must be greater than 1 to be Prime
    if number > 1:
      # Iterate through each number starting from 2 (as Prime numbers are divisble by 1)
      # Use each number from range (i) through to the number preeceding input number (as input number is divisible by itself)
        for i in range(2, number):
            # take input number we are checking and divide it by the range number using module for remainder
            result = number % i
            # if number is prime we expect it to have a remainder, but if it does not have a remainder(0) then we should stop the loop and return False
            if result == 0:
                return False
        # If we successfully loop through every number between 2 and the input number and always have a remainder, then our number is Prime
        return True
    else:
        # If input number is 1 or less we return False because it's not Prime
        return False

# Example
# print(is_prime(10))
# False
