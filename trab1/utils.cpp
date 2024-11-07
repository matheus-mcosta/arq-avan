#include <vector>


struct Row {
    int id;
    int timestamp;
    float value;
    int valid;
};

void merge(std::vector<Row>& arr, int left, int mid, int right, int column) {
    std::vector<Row> temp(right - left + 1);
    int i = left, j = mid + 1, k = 0;
    
    auto compare = [column](const Row& a, const Row& b) {
        switch(column) {
            case 0: return a.id < b.id;
            case 1: return a.timestamp < b.timestamp;
            case 2: return a.value < b.value;
            case 3: return a.valid < b.valid;
            default: return false;
        }
    };

    while (i <= mid && j <= right) {
        if (compare(arr[i], arr[j])) {
            temp[k++] = arr[i++];
        } else {
            temp[k++] = arr[j++];
        }
    }

    while (i <= mid) temp[k++] = arr[i++];
    while (j <= right) temp[k++] = arr[j++];

    for (i = 0; i < k; i++) {
        arr[left + i] = temp[i];
    }
}

void mergeSort(std::vector<Row>& arr, int left, int right, int column) {
    if (left < right) {
        int mid = left + (right - left) / 2;
        mergeSort(arr, left, mid, column);
        mergeSort(arr, mid + 1, right, column);
        merge(arr, left, mid, right, column);
    }
}

void sort(std::vector<Row>& arr, int column) {
    mergeSort(arr, 0, arr.size() - 1, column);
}