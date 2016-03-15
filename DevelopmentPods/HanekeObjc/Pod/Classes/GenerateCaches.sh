#!/bin/bash
sed s/UIImage/String/g ImageCache.swift > StringCache.swift
sed -i '' 's/ImageCache/StringCache/g' StringCache.swift
sed -i '' 's/ImageFetch/StringFetch/g' StringCache.swift

sed s/UIImage/NSData/g ImageCache.swift > DataCache.swift
sed -i '' 's/ImageCache/DataCache/g' DataCache.swift
sed -i '' 's/ImageFetch/DataFetch/g' DataCache.swift

