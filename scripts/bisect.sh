#!/bin/sh -e
#
# Copyright (c) 2012 Robert Nelson <robertcnelson@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

DIR=$PWD

if [ ! -f ${DIR}/patches/bisect_defconfig ] ; then
	cp ${DIR}/patches/defconfig ${DIR}/patches/bisect_defconfig
fi

cp -v ${DIR}/patches/bisect_defconfig ${DIR}/patches/defconfig

cd ${DIR}/KERNEL/
git bisect start
git bisect good v3.13
git bisect bad v3.14
git bisect good 82c477669a4665eb4e52030792051e0559ee2a36
git bisect bad ca2a650f3dfdc30d71d21bcbb04d2d057779f3f9
git bisect good 853dc21bfe15f545347b5c82aad02735d552110d
git bisect bad d12de1ef5eba3adb88f8e9dd81b6a60349466378
git bisect good 2fa053a0a27440ba2ada7acbc0afb11cdae243b2
git bisect good 15333539a9b3022656f815f643a77f6b054b335f
git bisect good 8aeab58e560da02772d6018eb4d6923514476a04
git bisect bad 945be38caa287b177b8c17ffaae7754cab6a658f
git bisect bad 3b159a6e955c8d468f4ffa212c8b5d68d8323a8d
git bisect good dd006b3081ccf01ee5ef07dcf8ff274626dbf80b
git bisect good c1b55bfcb3e5599eb5e67efed70698ade02add4e
git bisect bad 6c3331d3ace7989688fa59f541f5e722e44ac373
git bisect bad a91fe279ae750d67d65039bb4ac2cc6ef51e7a2a

git describe
cd ${DIR}/
