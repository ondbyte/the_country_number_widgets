![header](https://i.imgur.com/xiil4Wj.jpg)
# the_country_number_widgets
A small widgets library for flutter based on *![the_country_number](https://github.com/ondbyte/the_country_number)*

A simple form-field for international phone number input
```dart
//with prefilled number
final currentNumber = TheCountryNumber().parse(internationalNumber:"+97156565656");
TheCountryNumberInput(
  currentNumber,
  onChanged: (tn) {
    _enteredNumber = tn;
    if(_enteredNumber.isValidLength){
      //do something
    }
  }, 
)
//with only prefix
final numberWithOnlyPrefix = currentNumber.removeNumber();
TheCountryNumberInput(
  numberWithOnlyPrefix,
  onChanged: (tn) {
    _enteredNumber = tn;
    if(_enteredNumber.isValidLength){
      //do something
    }
  }, 
)
```
*keep in mind that some countries support phone numbers of multiple lengths, which is supported too*


Note: This license has also been called the "New BSD License" or "Modified BSD License". See also the 2-clause BSD License.

Copyright 2020 www.yadunandan.xyz

<a href="https://www.buymeacoffee.com/ondbyte" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.