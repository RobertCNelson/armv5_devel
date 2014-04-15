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
git bisect good v3.14
git bisect bad v3.15-rc1
git bisect good cd6362befe4cc7bf589a5236d2a780af2d47bcc9
git bisect bad d2b150d0647e055d7a71b1c33140280550b27dd6
git bisect good 24e7ea3bea94fe05eae5019f5f12bcdc98fc5157
git bisect bad 930b440cd8256f3861bdb0a59d26efaadac7941a
git bisect good 9f800363bb0ea459e15bef0928a72c88d374e489
git bisect bad 9233087dc468f75bdeb7830c694c09dc74be88c4
git bisect bad 1760e4f855a2ead08a40deac9abd4fb8cdf3af32
git bisect good 1e871089f66416ce540d8e362225a0878a5d2c06
git bisect bad da9e92613526a1527df3a216fcc58f69948c3570
git bisect bad c0bea59ca58e30fb8fd29254569bdaae482398ad
git bisect bad 0676b21fffd17baeff5893e02ed52a9407999cbf
git bisect bad 90bc8ac77dc85d2184da3d5280215b33253adffc
git bisect bad ddb902cc34593ecb88c368f6e15db3cf829c56fe

git describe
cd ${DIR}/
