#!/bin/bash
# Copyright (c) 2016 PaddlePaddle Authors. All Rights Reserved
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#set -e

# Note: if using trainer_config.emb.py, trainer_config.cnn.py
# or trainer_config.lstm.py, you need to change --seq to --seq=1
# because they are sequence models.
julia api_train.jl trainer_config.lr.jl 2 1 0 0 data/train.txt data/test.txt data/dict.txt

# config
# trainer_count
# num passes
# use gpu
# seq
# train data
# test_data
# dict file
#2>&1 | tee 'train.log'